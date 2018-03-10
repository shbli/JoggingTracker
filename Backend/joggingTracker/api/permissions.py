from django.contrib.auth.models import Group
from rest_framework import permissions

from api import serializers


class IsOwnerOrRecordsAdmin(permissions.BasePermission):
    """
    Custom permission to only allow owners of an object to see and edit it.
    Admin users however have access to all.
    """
    def has_object_permission(self, request, view, obj):
        # Permissions are only allowed to the owner of the snippet
        # admins are allowed to edit any object
        if request.user.groups.filter(name='RecordsAdmin').exists():
            return True
        if request.user.groups.filter(name='Admin').exists():
            return True
        if request.user.is_staff:
            return True
        # users are allowed to edit their own objects
        return obj.author_id == request.user.id


class IsUserManagerOrAdminOrOwner(permissions.BasePermission):
    """
    Custom permission to only allow user managers or admins.
    """
    def has_object_permission(self, request, view, obj):
        # Permissions are only allowed to the owner of the snippet
        # admins are allowed to edit any object
        if request.user.groups.filter(name='Admin').exists():
            return True
        if request.user.groups.filter(name='UserManager').exists():
            # A User manager is denied editing Admins, only GET is allowed for a user manager
            if request.method != 'GET':
                if request.method == 'POST' or request.method == 'PUT':
                    request_groups = request.data['groups']
                    admin_group_id = Group.objects.get(name='Admin').id
                    if admin_group_id in request_groups:
                        return False
                if obj.groups.filter(name='Admin').exists():
                    return False
            return True
        if request.user.is_staff:
            return True
        # users are allowed to edit their own objects
        return obj.id == request.user.id
