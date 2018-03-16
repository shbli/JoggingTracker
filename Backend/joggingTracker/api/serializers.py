from django.contrib.auth.models import User, Group
from rest_framework import serializers
from . import models


# The admin jog serializer shows the author id
class AdminJogSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Jog
        fields = (
            'id', 'author', 'notes', 'activity_start_time',
            'distance', 'time',
            'created', 'modified')


# The serializer forces the creator to only edit his own fields (Does not see the author id)
class JogSerializer(serializers.ModelSerializer):
    author = serializers.HiddenField(default=serializers.CurrentUserDefault())

    class Meta:
        model = models.Jog
        fields = (
            'id', 'author', 'notes', 'activity_start_time',
            'distance', 'time',
            'created', 'modified')

        # Force the author to logged in user
        def perform_create(self, serializer):
            serializer.save(author_id=self.request.user.id)

        def perform_update(self, serializer):
            serializer.save(author_id=self.request.user.id)


# Serialize for regular users
class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('id', 'username', 'first_name', 'last_name', 'email', 'password')

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        instance = self.Meta.model(**validated_data)
        if password is not None:
            instance.set_password(password)
        group = Group.objects.get(name='RegularUser')
        instance.save()
        instance.groups.add(group)
        return instance


class UserAdminSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ('id', 'username', 'first_name', 'last_name', 'email', 'password', 'groups')

    def create(self, validated_data):
        # Here the group item have to be popped first before any validation happens
        # if we pop the password first, we will get an exception
        groups = validated_data.pop('groups', None)
        instance = self.Meta.model(**validated_data)
        password = validated_data.pop('password', None)
        if password is not None:
            instance.set_password(password)
        instance.save()
        if groups is not None:
            instance.groups.set(groups)
        return instance

    def update(self, instance, validated_data):
        for attr, value in validated_data.items():
            if attr == 'password':
                if value is not None:
                    if value is not '':
                        instance.set_password(value)
            elif attr == 'groups':
                instance.groups.set(value)
            else:
                setattr(instance, attr, value)
        instance.save()
        return instance


# Special case, when updating a user, we can leave the password field blank, thus it will be ignored
class UserAdminSerializerPut(UserAdminSerializer):
    password = serializers.CharField(write_only=True, allow_blank=True, allow_null=True)
