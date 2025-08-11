# sample-pypi-package

Learning sandbox repository for creating Python packages

## Code

src
└───readyperfectly
    │   example.py  (additive_inverse function)
    │   __init__.py
    │
    ├───add_package
    │       example.py (add_two function)
    │       __init__.py
    │
    └───mult_package
            example.py (multiply_two function)
            __init__.py

This is a demostration of how we can have modules and packages in a repository.

TODO: Another branch where we publish different pypi packages for each package.


## Build (local)

This repository uses the following packages for publishing packages to Python Package Index (PyPI) :

1.  packaging   -- Reusable core utilities for various Python Packaging
2.  hatchling   -- Build backend for Python projects used by the Hatch project manager.
3.  twine       -- Utility used for uploading Python packages to PyPi

Command to install required packages

```
python.exe -m pip install --upgrade pip
python.exe -m pip install --upgrade packaging twine hatchling
```

## Version number

Version number of packages are set using "RELEASE_VERSION" environment variable.
This is set in pyproject.toml file in the "tool.hatch.version" section

```toml - File: pyproject.toml
[tool.hatch.version]
source = "env"
variable = "RELEASE_VERSION"
```

## Publishing

To publish to PyPi (or TestPypi), you need to set some environment variables:

```pwsh
$env:TWINE_USERNAME = "__token__"
$env:TWINE_PASSWORD = "pypi-<some-cryptographic-hash>"
```