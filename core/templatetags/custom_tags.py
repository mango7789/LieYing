from django import template

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
