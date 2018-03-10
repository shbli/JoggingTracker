from django.db.models import Func
from api import serializers


# Custom response for the login method
def jwt_response_payload_handler(token, user=None, request=None):
    data = serializers.UserAdminSerializer(user, context={'request': request}).data
    data['token'] = token
    return data


class WeekFunc(Func):
    def as_mysql(self, compiler, connection):
        self.function = 'WEEK'
        return super().as_sql(compiler, connection)


class YearFunc(Func):
    def as_mysql(self, compiler, connection):
        self.function = 'YEAR'
        return super().as_sql(compiler, connection)
