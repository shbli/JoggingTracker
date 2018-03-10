from django.db.models import IntegerField, Avg
from django.core import serializers
from rest_framework import viewsets
from rest_framework.decorators import list_route, detail_route
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_jwt.views import ObtainJSONWebToken

from api.permissions import IsOwnerOrRecordsAdmin, IsUserManagerOrAdminOrOwner
from django.contrib.auth.models import User
from . import models
from . import serializers
from . import utils


class ReportView(APIView):
    """
    API View that returns a JSON report on average jogging time and distance per week for user.
    """
    def get(self, request, *args, **kwargs):
        db_result = models.Jog.objects. \
            annotate(week=utils.WeekFunc('activity_start_time', output_field=IntegerField()),
                     year=utils.YearFunc('activity_start_time', output_field=IntegerField())).values('week', 'year') \
            .annotate(avg_distance=Avg('distance'), avg_time=(Avg('time')))
        return Response(list(db_result))


class JogViewSet(viewsets.ModelViewSet):
    """
    API ViewSet that allows to you to create(POST), get(GET), edit(PUT) or delete(DELETE) jog records
    """
    queryset = models.Jog.objects.all()

    def get_queryset(self):
        if self.request.user.groups.filter(name='Admin').exists() \
                or self.request.user.groups.filter(name='RecordsAdmin').exists():
            return self.queryset

        user = self.request.user
        return self.queryset.filter(author_id=user)

    def get_permissions(self):
        self.permission_classes = (IsAuthenticated, IsOwnerOrRecordsAdmin)
        return super(JogViewSet, self).get_permissions()

    def get_serializer_class(self):
        # Admins get access to full user details including the author field (Can edit anyone)
        if self.request.user.groups.filter(name='Admin').exists() \
                or self.request.user.groups.filter(name='RecordsAdmin').exists():
            return serializers.AdminJogSerializer
        return serializers.JogSerializer


class UserViewSet(viewsets.ModelViewSet):
    """
    API ViewSet that allows to you to create(POST), get(GET), edit(PUT) or delete(DELETE) users
    """

    queryset = User.objects.all()

    def get_queryset(self):
        if self.request.user.is_anonymous:
            return User.objects.none()
        # Admins and UserManager can see all users without a filter
        if self.request.user.groups.filter(name='Admin').exists() \
                or self.request.user.groups.filter(name='UserManager').exists():
            return self.queryset
        # All other regular users can see their own accounts only
        user = self.request.user
        return self.queryset.filter(id=user.id)

    def get_serializer_class(self):
        # Admins get access to full user details include changing permissions
        if self.request.user.groups.filter(name='Admin').exists():
            if self.request.method == 'PUT':
                return serializers.UserAdminSerializerPut
            return serializers.UserAdminSerializer
        # Get show everything, so the mobile app can show the appropriate views based on the user group and permission
        if self.request.method == 'GET':
            return serializers.UserAdminSerializer
        return serializers.UserSerializer

    def get_permissions(self):
        self.permission_classes = (AllowAny, IsUserManagerOrAdminOrOwner)
        return super(UserViewSet, self).get_permissions()