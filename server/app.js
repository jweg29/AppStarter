const express = require('express');

const mongoose = require('mongoose');

const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// DB Connection

mongoose.connect('mongodb://localhost:27017/todoDB', { useNewUrlParser: true, useUnifiedTopology: true, useFindAndModify: false });

const todoSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
});
const Todo = mongoose.model('Todo', todoSchema);

// Routes

app.get('/api/todo', (request, response) => {
  console.log('/todo GET');
  Todo.find((error, todos) => {
    if (error) {
      return response.status(500).send(error);
    }
    return response.status(200).send(todos);
  });
}).post('/api/todo', (request, response) => {
  console.log('/todo POST');
  const { name } = request.body;
  if (name) {
    const newTodo = new Todo({
      name,
    });
    newTodo.save();
    response.status(201).send(newTodo);
  } else {
    response.status(400).send('Missing name parameter');
  }
}).put('/api/todo', (request, response) => {
  console.log('/todo PUT');
  const { id } = request.body;
  const { name } = request.body;

  if (id) {
    Todo.findById(id, (error, result) => {
      if (error) {
        response.status(500).send(error);
      }

      const todo = result;
      if (todo) {
        todo.name = name;
        todo.save();
        response.status(200).send(todo);
      } else {
        response.status(404).send('Todo with ID not found');
      }
    });
  } else {
    response.status(400).send('Missing ID parameter');
  }
}).delete('/api/todo', (request, response) => {
  console.log('/todo DELETE');
  const { ids } = request.body;

  if (ids) {
    ids.forEach((id) => {
      Todo.findByIdAndRemove(id, (error, result) => {
        if (error) {
          response.status(500).send(error);
        }

        const todo = result;
        if (todo) {
          response.status(200).send('Todo deleted'.json);
        } else {
          response.status(404).send('Todo with ID not found'.json);
        }
      });
    });
  } else {
    response.status(400).send('Missing IDS parameter');
  }
});

app.listen(8080, () => console.log('Server started on port 8080'));
