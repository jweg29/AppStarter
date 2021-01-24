import React from 'react';
import PropTypes from 'prop-types';

function Todo(props) {
  Todo.propTypes = {
    didTapDelete: PropTypes.func.isRequired,
    todo: PropTypes.shape({
      name: PropTypes.string,
    }).isRequired,
  };

  function didTapDeleteButton() {
    props.didTapDelete(props.todo);
  }

  return (
    <div className="Todo">
      <p className="todo-p">{props.todo.name}</p>
      <div className="todo-button">
        <button type="button" onClick={didTapDeleteButton}>
          Delete
        </button>
      </div>
    </div>
  );
}

export default Todo;
