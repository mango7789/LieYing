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
