from django.contrib.auth.models import User, Group
from django.test import TestCase, Client
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APIRequestFactory, force_authenticate
from api.views import UserViewSet, JogViewSet
from . import models
from . import serializers
from datetime import timezone, datetime

# initialize the APIClient app
client = Client()


class TestAPIs(TestCase):
    fixtures = ['fixtures/datadump.json',]
    datetime_now = datetime.now(tz=timezone.utc)

    def get_admin(self):
        return User.objects.get(username='shbli')

    def get_usermanager(self):
        return User.objects.get(username='usermanager')

    def get_regularuser(self):
        return User.objects.get(username='user')

    def setUp(self):
        models.Jog.objects.create(author=self.get_regularuser(), notes='Note', created=self.datetime_now, modified=self.datetime_now, activity_start_time=self.datetime_now, distance=1000, time=5)
        models.Jog.objects.create(author=self.get_regularuser(), notes='Note 2', created=self.datetime_now, modified=self.datetime_now, activity_start_time=self.datetime_now, distance=1000, time=6)

    def test_user_model(self):
        self.assertTrue(self.get_admin().groups.filter(name='Admin').exists())
        self.assertTrue(self.get_usermanager().groups.filter(name='UserManager').exists())
        self.assertTrue(self.get_regularuser().groups.filter(name='RegularUser').exists())

        self.assertEqual(self.get_regularuser().email, "user@shbli.com")

    def test_auth_user(self):
        response = client.post(path='/api/token-auth/', data={'username': 'shbli', 'password': 'shbli12345'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Test invalid credentials
        response = client.post(path='/api/token-auth/', data={'username': 'admin', 'password': 'wrongpassword'})
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        # Test invalid request
        response = client.post(path='/api/token-auth/', data={'username': 'admin'})
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_get_all_users(self):
        factory = APIRequestFactory()
        view = UserViewSet.as_view(actions={'get': 'list'})
        request = factory.get(reverse('user-list'))

        users = User.objects.all()
        serializer = serializers.UserAdminSerializer(users, many=True)

        # Test the request with the admin
        force_authenticate(request, user=self.get_admin())
        response = view(request)

        self.assertEqual(response.data, serializer.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Test the request with the user manager
        force_authenticate(request, user=self.get_usermanager())
        response = view(request)

        self.assertEqual(response.data, serializer.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_user(self):
        factory = APIRequestFactory()
        view = UserViewSet.as_view(actions={'post': 'create'})
        request = factory.post(reverse('user-list'), data={'username': 'new_user', 'password': 'password', 'email': 'some@some.com', 'first_name': 'user', 'last_name': 'last'}, format='json')

        response = view(request)

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_update_user(self):
        user_id = User.objects.get(username='user7').id
        factory = APIRequestFactory()
        view = UserViewSet.as_view(actions={'put': 'update'})
        request = factory.put(reverse('user-detail', kwargs={'pk': user_id}), data={'username': 'new_user', 'password': 'password', 'email': 'newuniqueemail@some.com', 'first_name': 'user', 'last_name': 'last'})

        # Test the request with the admin
        force_authenticate(request, user=self.get_admin())
        response = view(request, pk=user_id)

        self.assertEqual(User.objects.get(id=user_id).email, 'newuniqueemail@some.com')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_update_empty_password_user(self):
        user_id = User.objects.get(username='user7').id
        user_password = User.objects.get(username='user7').password
        self.assertEqual(User.objects.get(id=user_id).password, user_password)
        factory = APIRequestFactory()
        view = UserViewSet.as_view(actions={'put': 'update'})
        request = factory.put(reverse('user-detail', kwargs={'pk': user_id}), data={'username': 'new_user', 'password': '', 'email': 'newuniqueemail@some.com', 'first_name': 'user', 'last_name': 'last'})

        # Test the request with the admin
        force_authenticate(request, user=self.get_admin())
        response = view(request, pk=user_id)

        self.assertEqual(User.objects.get(id=user_id).email, 'newuniqueemail@some.com')
        self.assertEqual(User.objects.get(id=user_id).password, user_password)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_delete_user(self):
        username = 'user6'
        # Let's make sure the user exist on the database first
        self.assertTrue(User.objects.filter(username=username).exists())

        # Delete the user as a user manager
        user_id = User.objects.get(username=username).id
        factory = APIRequestFactory()
        view = UserViewSet.as_view(actions={'delete': 'destroy'})
        request = factory.delete(reverse('user-detail', kwargs={'pk': user_id}))

        # Test the request with the admin
        force_authenticate(request, user=self.get_usermanager())
        response = view(request, pk=user_id)

        # Confirm the deletion of that user
        self.assertFalse(User.objects.filter(username=username).exists())
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

    # User manager tries to delete an admin
    def test_delete_user_unauthorized(self):
        username = 'shbli'
        # Let's make sure the user exist on the database first
        self.assertTrue(User.objects.filter(username=username).exists())

        # Delete the user as a user manager
        user_id = User.objects.get(username=username).id
        factory = APIRequestFactory()
        view = UserViewSet.as_view(actions={'delete': 'destroy'})
        request = factory.delete(reverse('user-detail', kwargs={'pk': user_id}))

        # Test the request with the usermanager
        force_authenticate(request, user=self.get_usermanager())
        response = view(request, pk=user_id)

        # Make sure the user is still in the database
        self.assertTrue(User.objects.filter(username=username).exists())
        # Forbidden should be returned
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

        # Test the request with the regular user
        force_authenticate(request, user=self.get_regularuser())
        response = view(request, pk=user_id)

        # Make sure the user is still in the database
        self.assertTrue(User.objects.filter(username=username).exists())
        # Not found, these users have no access to this API
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_jog_model(self):
        five_minute_jog = models.Jog.objects.get(time=5, author=self.get_regularuser(), distance=1000)
        six_minute_jog = models.Jog.objects.get(time=6, author=self.get_regularuser(), distance=1000)
        self.assertEqual(
            five_minute_jog.notes, 'Note')
        self.assertEqual(
            six_minute_jog.notes, 'Note 2')

    def test_get_all_jogs(self):
        factory = APIRequestFactory()
        view = JogViewSet.as_view(actions={'get': 'list'})
        request = factory.get(reverse('jog-list'))

        # Test the request with the an admin
        jogs = models.Jog.objects.all()
        serializer = serializers.AdminJogSerializer(jogs, many=True)
        force_authenticate(request, user=self.get_admin())
        response = view(request)

        self.assertEqual(response.data, serializer.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Test the request with a regular user
        jogs = models.Jog.objects.all().filter(author=self.get_regularuser())
        serializer = serializers.JogSerializer(jogs, many=True)
        force_authenticate(request, user=self.get_regularuser())
        response = view(request)

        self.assertEqual(response.data, serializer.data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_jog(self):
        factory = APIRequestFactory()
        view = JogViewSet.as_view(actions={'post': 'create'})

        request = factory.post(reverse('jog-list'), data={'author': self.get_regularuser().id, 'notes': 'Random notes',
                                                          'created': self.datetime_now, 'modified': self.datetime_now,
                                                          'activity_start_time': self.datetime_now,
                                                          'distance': 1000, 'time': 6}, format='json')

        force_authenticate(request, user=self.get_admin())
        response = view(request)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        force_authenticate(request, user=self.get_regularuser())
        response = view(request)
        # Normal users are not allowed to pass in the author parameter
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

        request = factory.post(reverse('jog-list'), data={'notes': 'Random notes',
                                                          'created': self.datetime_now, 'modified': self.datetime_now,
                                                          'activity_start_time': self.datetime_now,
                                                          'distance': 1000, 'time': 6}, format='json')
        force_authenticate(request, user=self.get_regularuser())
        response = view(request)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

    def test_update_jog(self):
        jog_id = models.Jog.objects.get(time=5, author_id=self.get_regularuser().id, distance=1000).id
        print('jog id')
        print(jog_id)
        factory = APIRequestFactory()
        view = JogViewSet.as_view(actions={'put': 'update'})
        request = factory.put(reverse('jog-detail', kwargs={'pk': jog_id}), data={'notes': 'New unique note',
                                                                                   'created': self.datetime_now, 'modified': self.datetime_now,
                                                                                   'activity_start_time': self.datetime_now,
                                                                                   'distance': 1000, 'time': 6})

        # Test the request without authentication
        response = view(request, pk=jog_id)

        self.assertNotEqual(models.Jog.objects.get(id=jog_id).notes, 'New unique note')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

        force_authenticate(request, user=self.get_regularuser())
        response = view(request, pk=jog_id)

        self.assertEqual(models.Jog.objects.get(id=jog_id).notes, 'New unique note')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_delete_jog(self):
        jog_id = models.Jog.objects.get(time=5, author_id=self.get_regularuser().id, distance=1000).id
        # Let's make sure the jog exist on the database first
        self.assertTrue(models.Jog.objects.filter(id=jog_id).exists())

        # Delete the jog as an admin
        factory = APIRequestFactory()
        view = JogViewSet.as_view(actions={'delete': 'destroy'})
        request = factory.delete(reverse('jog-detail', kwargs={'pk': jog_id}))

        # Test the request without authentication
        response = view(request, pk=jog_id)

        # Confirm the deletion is not accepted
        self.assertTrue(models.Jog.objects.filter(id=jog_id).exists())
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

        # Test the request with the admin
        force_authenticate(request, user=self.get_admin())
        response = view(request, pk=jog_id)

        # Confirm the deletion of that object is performed
        self.assertFalse(models.Jog.objects.filter(id=jog_id).exists())
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
