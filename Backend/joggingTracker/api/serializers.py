from django.contrib.auth.models import User, Group
from rest_framework import serializers
from . import models


class JogSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Jog
        fields = (
            'id', 'author', 'notes', 'activity_start_time',
            'distance', 'time',
            'created', 'modified')


# Serialize for regular users
class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('id', 'username', 'first_name', 'last_name', 'email', 'password')

    def create(self, validated_data):
        user = super(UserSerializer, self).create(validated_data)
        user.set_password(validated_data['password'])
        group = Group.objects.get(name='RegularUser')
        user.groups.add(group)
        user.save()
        return user


# Serialize for admin users
class UserAdminSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('id', 'username', 'first_name', 'last_name', 'email', 'password', 'groups')

    def create(self, validated_data):
        user = super(UserAdminSerializer, self).create(validated_data)
        user.set_password(validated_data['password'])
        group = Group.objects.get(name='RegularUser')
        user.groups.add(group)
        user.save()
        return user
