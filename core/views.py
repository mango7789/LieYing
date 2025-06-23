import json
import logging
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from .utils.crypto import encrypt_params


# Create your views here.
@csrf_exempt
def encrypt(request):
    if request.method == "POST":
        try:
            body_unicode = request.body.decode("utf-8")
            data = json.loads(body_unicode)
            logging.debug(f"解析后的数据：{data}")

            encrypted = encrypt_params(data)

            return JsonResponse({"q": encrypted})

        except Exception as e:
            print("加密失败，异常：", e)
            return JsonResponse({"error": str(e)}, status=400)
