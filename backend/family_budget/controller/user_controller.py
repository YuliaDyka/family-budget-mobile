from flask import abort
from http import HTTPStatus

from .general_controller import GeneralController
from family_budget.model import User

class UserController(GeneralController):
    _model_type = User

    def login(self, email: str, password: str) -> object:
        """
        Gets object from database table by integer key using from Service layer.
        :param key: integer key (surrogate primary key)
        :return: DTO for search object
        """
        obj = self._session.query(self._model_type).filter_by(email=email, password=password).first()
        if obj is None:
            abort(HTTPStatus.NOT_FOUND)
        return obj.put_into_dto()
    
    def get_by_email(self, email: str) -> object:
        """
        Gets object from database table by integer key using from Service layer.
        :param key: integer key (surrogate primary key)
        :return: DTO for search object
        """
        obj = self._session.query(self._model_type).filter_by(email=email).first()
        if obj is None:
            abort(HTTPStatus.NOT_FOUND)
        return obj.put_into_dto()
    
    
