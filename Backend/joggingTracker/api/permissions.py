from rest_framework import permissions


class IsOwnerOrAdmin(permissions.BasePermission):
    """
    Custom permission to only allow owners of an object to see and edit it.
    Admin users however have access to all.
    """
    def has_object_permission(self, request, view, obj):
        # Permissions are only allowed to the owner of the snippet
        #admins are allowed to edit any object
        if request.user.groups.filter(name='RecordsAdmin').exists():
            return True
        if request.user.groups.filter(name='Admin').exists():
            return True
        if request.user.is_staff:
            return True
        #users are allowed to edit their own objects
        return obj.author_id == request.user.id


class IsUserManagerOrAdmin(permissions.BasePermission):
    """
    Custom permission to only allow user managers or admins.
    """
    def has_permission(self, request, view):
        # Permissions are only allowed to the owner of the snippet
        # admins are allowed to edit any object
        if request.user.groups.filter(name='RecordsAdmin').exists():
            return True
        if request.user.groups.filter(name='Admin').exists():
            return True
        if request.user.groups.filter(name='UserManager').exists():
            return True
        if request.user.is_staff:
            return True
        return False
