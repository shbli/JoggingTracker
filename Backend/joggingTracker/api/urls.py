from django.urls import path, include
from rest_framework import routers
from . import views
from rest_framework_jwt.views import obtain_jwt_token

router = routers.DefaultRouter()
router.register('jogs', views.JogViewSet)
router.register('users', views.UserViewSet)

urlpatterns = [
    path('', include(router.urls)),
    # Token API package
    # http://getblimp.github.io/django-rest-framework-jwt/
    path('token-auth/', obtain_jwt_token),
]