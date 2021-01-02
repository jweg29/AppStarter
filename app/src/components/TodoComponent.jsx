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
      <p>{props.todo.name}</p>
      <button type="button" onClick={didTapDeleteButton}>
        Delete
      </button>
    </div>
  );
}

export default Todo;
