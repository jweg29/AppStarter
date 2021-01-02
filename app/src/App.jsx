/* eslint-disable no-underscore-dangle */
import React from 'react';
import './App.css';
import CreateTodo from './components/CreateTodoComponent';
import Todo from './components/TodoComponent';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      todos: [],
    };

    // TODO: This constructor method binding doesn't seem to work?
    this.reloadTodos.bind(this);
    this.didTapCreateTodo.bind(this);
    this.didTapDeleteTodo.bind(this);
  }

  componentDidMount() {
    this.reloadTodos();
  }

  createTodoComponent(todo) {
    // TODO: Resolve warning
    return (
      <Todo
        key={todo._id}
        todo={todo}
        didTapDelete={this.didTapDeleteTodo.bind(this)}
      />
    );
  }

  reloadTodos() {
    fetch('api/todo')
      .then((response) => response.json())
      .then((result) => {
        this.setState({ todos: result });
      });
  }

  didTapCreateTodo(todo) {
    const requestInfo = {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        name: todo.name,
      }),
    };

    fetch('api/todo', requestInfo).then(() => {
      this.reloadTodos();
    });
  }

  didTapDeleteTodo(todo) {
    const requestInfo = {
      method: 'DELETE',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        id: todo._id,
      }),
    };

    fetch('api/todo', requestInfo).then(
      () => {
        this.reloadTodos();
      },
      (error) => {
        console.log('didTapDeleteTodo error');
        this.setState({
          error,
        });
      },
    );
  }

  render() {
    const { todos } = this.state;
    return (
      <div className="App">
        <header className="App-header">
          <h1>Todo ✅</h1>
          {/* TODO: Resolve warning */}
          <CreateTodo didTapCreate={this.didTapCreateTodo.bind(this)} />
          <div className="TodoList">
            <p>{this.state.error}</p>
            <h3>Todos</h3>
            <ul>
              {todos.map((todo) => (
                <li key={todo._id}>{this.createTodoComponent(todo)}</li>
              ))}
            </ul>
          </div>
        </header>
      </div>
    );
  }
}

export default App;
