"""This module provides a portable way of using operating system dependent functionality."""
import os


def get_path(template_html: any):
    """This function get path template and return os location"""
    app_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    path = os.path.join(app_path, template_html)
    return path
