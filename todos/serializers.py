from rest_framework import serializers

from .models import Todo

class TodoSerializer(serializers.ModelSerializer):

    class Meta:
        model = Todo
        fields = ['id', 'is_completed', 'title', 'created_at', 'description']
        read_only_fields = ['id', 'created_at']