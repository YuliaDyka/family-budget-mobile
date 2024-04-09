from http import HTTPStatus
from flask import Blueprint, jsonify, Response, request, make_response

from family_budget.controller import user_controller
from family_budget.model import User

user_bp = Blueprint('user', __name__, url_prefix='/user')

@user_bp.get('')
def get_all_users() -> Response:
    """
    Gets all objects from table
    :return: Response object
    """
    return make_response(jsonify(user_controller.find_all()), HTTPStatus.OK)


@user_bp.post('')
def create_user() -> Response:
    """
    Gets all objects from table using Service layer.
    :return: Response object
    """
    content = request.get_json()
    if User.query.filter_by(email=content['email']).first():
            return make_response("User with this email already exists", 409)
    
    user = User.create_from_dto(content)
    user_controller.create(user)
    return make_response(jsonify(user.put_into_dto()), HTTPStatus.CREATED)


@user_bp.post('/login')
def login_user() -> Response:
    """
    Gets all objects from table using Service layer.
    :return: Response object
    """
    content = request.get_json()
    # user = User.create_from_dto(**content)
    # user_controller.create(user)
    return make_response(jsonify(user_controller.login(**content)), HTTPStatus.CREATED)


@user_bp.get('/<int:user_id>')
def get_user(user_id: int) -> Response:
    """
    Gets user by ID.
    :return: Response object
    """
    return make_response(jsonify(user_controller.find_by_id(user_id)), HTTPStatus.OK)


@user_bp.put('/<int:user_id>')
def update_user(user_id: int) -> Response:
    """
    Updates user_id by ID.
    :return: Response object
    """
    content = request.get_json()
    user = User.create_from_dto(content)
    user_controller.update(user_id, user)
    return make_response("User updated", HTTPStatus.OK)


@user_bp.delete('/<int:user_id>')
def delete_user(user_id: int) -> Response:
    """
    Deletes user_id by ID.
    :return: Response object
    """
    user_controller.delete(user_id)
    return make_response("User deleted", HTTPStatus.OK)

@user_bp.get('by_email/<string:email>')
def get_user_by_email(email) -> Response:
    """
    Gets  user by email.
    :return: Response object
    """
    # content = request.get_json()
    # user = User.create_from_dto(**content)
    # user_controller.create(user)
    return make_response(jsonify(user_controller.get_by_email(email)), HTTPStatus.CREATED)