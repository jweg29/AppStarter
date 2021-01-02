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
const List = mongoose.model('Todo', todoSchema);

// Routes

app.get('/api/todo', (request, response) => {
  console.log('/todo GET');
  List.find((error, lists) => {
    if (error) {
      return response.status(500).send(error);
    }
    return response.status(200).send(lists);
  });
}).post('/api/todo', (request, response) => {
  console.log('/todo POST');
  const { name } = request.body;
  if (name) {
    const newList = new List({
      name,
    });
    newList.save();
    response.status(201).send(newList);
  } else {
    response.status(400).send('Missing name parameter');
  }
}).put('/api/todo', (request, response) => {
  console.log('/todo PUT');
  const { id } = request.body;
  const { name } = request.body;

  if (id) {
    List.findById(id, (error, result) => {
      if (error) {
        response.status(500).send(error);
      }

      const list = result;
      if (list) {
        list.name = name;
        list.save();
        response.status(200).send(list);
      } else {
        response.status(404).send('Todo with ID not found');
      }
    });
  } else {
    response.status(400).send('Missing ID parameter');
  }
}).delete('/api/todo', (request, response) => {
  console.log('/todo DELETE');
  const { id } = request.body;
  console.log(id);

  if (id) {
    List.findByIdAndRemove(id, (error, result) => {
      if (error) {
        response.status(500).send(error);
      }

      const list = result;
      if (list) {
        response.status(200).send('Todo deleted'.json);
      } else {
        response.status(404).send('Todo with ID not found'.json);
      }
    });
  } else {
    response.status(400).send('Missing ID parameter');
  }
});

app.listen(8080, () => console.log('Server started on port 8080'));
