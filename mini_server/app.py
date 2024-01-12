# matrix_bridge/mini_server/app.py
"""Minimal codes for Matrix Bridge mod testing"""

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route("/", methods=("POST",))
def root():  # pylint: disable=missing-function-docstring
    content_type = request.headers.get('Content-Type')
    if content_type != 'application/json':
        return "Invalid content type", 400

    data = request.json
    print(data)

    # Return a dummy empty JSON
    return jsonify([])
