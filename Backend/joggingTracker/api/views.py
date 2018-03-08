from django.http import JsonResponse
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated, AllowAny
from api.permissions import IsOwnerOrRecordsAdmin, IsUserManagerOrAdminOrOwner
from django.contrib.auth.models import User
from . import models
from . import serializers


class JogViewSet(viewsets.ModelViewSet):
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
