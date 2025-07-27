from django import template
from urllib.parse import urlencode

register = template.Library()


@register.filter
def first_path_segment(path):
    """
    Return the first non-empty segment of a URL path.
    """
    if not path:
        return ""
    segments = path.strip("/").split("/")
    return segments[0] if segments else ""


@register.simple_tag
def querydict(get, key, value):
    query = get.copy()
    query[key] = value
    return query.urlencode()


@register.filter
def mul(value, arg):
    try:
        return int(value) * int(arg)
    except (ValueError, TypeError):
        return ""


@register.filter
def get_attr(obj, attr):
    return getattr(obj, f"{attr}_weight", "")


@register.filter
def get_item(dictionary, key):
    if dictionary is None:
        return None
    return dictionary.get(key)


@register.filter
def get_item_with_default(dictionary, args):
    """args 是 'key,default_value' 格式的字符串"""
    if not dictionary:
        return None
    key, default = args.split(",")
    return dictionary.get(key, default)
