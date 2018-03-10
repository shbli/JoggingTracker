from django.urls import path, include
from rest_framework import routers
from rest_framework.response import Response
from rest_framework.views import APIView
from . import views
from rest_framework_jwt.views import obtain_jwt_token


class DocsView(APIView):
    """
    RESTFul Documentation of the jog tracking APIs
    """
    def get(self, request, *args, **kwargs):
        apidocs = {'jogs': request.build_absolute_uri('jogs/'),
                   'users': request.build_absolute_uri('users/'),
                   'token-auth': request.build_absolute_uri('token-auth/'),
                   'weekly-report': request.build_absolute_uri('weekly-report/'),
                   }
        return Response(apidocs)


router = routers.DefaultRouter()
router.register('jogs', views.JogViewSet)
router.register('users', views.UserViewSet)


urlpatterns = [
    path('', DocsView.as_view()),
    path('', include(router.urls)),
    # Token API package
    # http://getblimp.github.io/django-rest-framework-jwt/
    path('token-auth/', obtain_jwt_token),
    path('weekly-report/', views.ReportView.as_view()),
    ]
