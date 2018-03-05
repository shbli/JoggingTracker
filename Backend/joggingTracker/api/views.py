from django.http import JsonResponse
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated, AllowAny
from api.permissions import IsOwnerOrAdmin, IsUserManagerOrAdmin
from django.contrib.auth.models import User
from . import models
from . import serializers


class JogViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.JogSerializer
    queryset = models.Jog.objects.all()

    def get_queryset(self):
        user = self.request.user
        return self.queryset.filter(author_id=user)

    def get_permissions(self):
        self.permission_classes = (IsAuthenticated, IsOwnerOrAdmin)
        return super(JogViewSet, self).get_permissions()


class UserViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.UserSerializer
    queryset = User.objects.all()

    def get_permissions(self):
        self.permission_classes = (IsAuthenticated, IsUserManagerOrAdmin)
        return super(UserViewSet, self).get_permissions()


def jog_list(request):

    userid = request.user.id

    print('user_id')
    print(userid)

    result = []


    for jog in models.Jog.objects.all():
        result.append({'name': jog.notes, 'distance': jog.distance, 'user_id': jog.author_id})

    return JsonResponse(result, safe=False)
