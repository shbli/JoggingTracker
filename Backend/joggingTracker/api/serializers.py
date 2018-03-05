from django.contrib.auth.models import User
from rest_framework import serializers
from . import models


class JogSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Jog
        fields = (
            'id', 'author', 'notes', 'activity_start_time',
            'distance', 'time',
            'created', 'modified')


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('id', 'first_name', 'last_name', 'email', 'password')

    def create(self, validated_data):
        user = super(UserSerializer, self).create(validated_data)
        user.set_password(validated_data['password'])
        user.save()
        return user