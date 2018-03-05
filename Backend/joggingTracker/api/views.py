from django.http import JsonResponse
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated, AllowAny
from api.permissions import IsOwnerOrRecordsAdmin, IsUserManagerOrAdminOrOwner
from django.contrib.auth.models import User, AnonymousUser
from . import models
from . import serializers


class JogViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.JogSerializer
    queryset = models.Jog.objects.all()

    def get_queryset(self):
        user = self.request.user
        return self.queryset.filter(author_id=user)

    def get_permissions(self):
        self.permission_classes = (IsAuthenticated, IsOwnerOrRecordsAdmin)
        return super(JogViewSet, self).get_permissions()


class UserViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.UserSerializer
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
        return self.queryset.filter(id=user)

    def get_serializer_class(self):
        # Admins get access to full user details include changing permissions
        if self.request.user.groups.filter(name='Admin').exists():
            return serializers.UserAdminSerializer
        return serializers.UserSerializer

    def get_permissions(self):
        self.permission_classes = (AllowAny, IsUserManagerOrAdminOrOwner)
        return super(UserViewSet, self).get_permissions()


def jog_list(request):
    userid = request.user.id

    print('user_id')
    print(userid)

    result = []

    for jog in models.Jog.objects.all():
        result.append({'name': jog.notes, 'distance': jog.distance, 'user_id': jog.author_id})

    return JsonResponse(result, safe=False)


def change_user_group(request):
    userid = ((request))
