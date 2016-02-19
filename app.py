from flask import Flask, request, jsonify
from tokens import Token
from auth import basic_auth_required


app = Flask(__name__)


def get_allowed_actions(user, actions):
    # determine what actions are allowed here
    return actions


@app.route('/tokens')
@basic_auth_required
def tokens():
    service = request.args.get('service')
    scope = request.args.get('scope')
    if not scope:
        typ = ''
        name = ''
        actions = []
    else:
        params = scope.split(':')
        if len(params) != 3:
            return jsonify(error='Invalid scope parameter'), 400
        typ = params[0]
        name = params[1]
        actions = params[2].split(',')

    authorized_actions = get_allowed_actions(request.user, actions)

    token = Token(service, typ, name, authorized_actions)
    encoded_token = token.encode_token()

    return jsonify(token=encoded_token)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
