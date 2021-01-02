import React from 'react';
import PropTypes from 'prop-types';

function CreateTodo(props) {
  CreateTodo.propTypes = {
    didTapCreate: PropTypes.func.isRequired,
  };

  const [todo, updateTodo] = React.useState({
    name: '',
  });

  function didTapCreate() {
    if (todo.name !== '') {
      props.didTapCreate(todo);
    } else {
      alert('Please enter a name for the new todo.');
    }

    document.getElementById('name').value = '';
    updateTodo({
      name: '',
    });
  }

  function handleFormSubmit(event) {
    event.preventDefault();
  }

  function didUpdateInput(event) {
    const { name, value } = event.target;
    event.preventDefault();
    updateTodo((prevState) => ({
      ...prevState,
      [name]: value,
    }));
  }

  return (
    <div className="createTodo">
      <h3>Create Todo</h3>
      <form onSubmit={handleFormSubmit}>
        <input
          id="name"
          name="name"
          placeholder="List name"
          onChange={didUpdateInput}
          autoComplete="off"
        />
        <button type="button" onClick={didTapCreate}>
          Create
        </button>
      </form>
    </div>
  );
}

export default CreateTodo;
