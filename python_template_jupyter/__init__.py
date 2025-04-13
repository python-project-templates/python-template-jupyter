__version__ = "0.1.0"


def _jupyter_server_extension_paths():
    return [{"module": "python_template_jupyter"}]


def _jupyter_server_extension_points():
    return [{"module": "python_template_jupyter"}]


def _load_jupyter_server_extension(nb_server_app, nb6_entrypoint=False):
    """
    Called when the extension is loaded.

    Args:
        nb_server_app (NotebookWebApplication): handle to the Notebook webserver instance.
    """
    # web_app = nb_server_app.web_app


def _jupyter_nbextension_paths():
    return [
        {
            "section": "tree",
            "src": "nbextension/static",
            "dest": "python_template_jupyter",
            "require": "python_template_jupyter/notebook",
        }
    ]
