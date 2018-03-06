from api import serializers


# Custom response for the login method
def jwt_response_payload_handler(token, user=None, request=None):
    data = serializers.UserAdminSerializer(user, context={'request': request}).data
    data['token'] = token
    return data
