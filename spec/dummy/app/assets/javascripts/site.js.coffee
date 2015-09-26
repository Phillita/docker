jQuery ->
  $('body').dock(
    title: 'My First Dock',
    tabs: [
      {
        title: 'Test Server',
        action: 'get',
        url: 'http://jsonplaceholder.typicode.com/posts',
        fieldNames: ['title', 'body'],
        format: '<p>Title: %0<br>Body: %1</p>',
        searchEnabled: true,
      }
    ]
  )
  # ALL OPTIONS
  # {
  #   title: String,
  #   action: get || post,
  #   dataType: json || jsonp || etc.,
  #   url: String,
  #   fieldNames: ['example', 'fields'],
  #   format: string using % + number strarting from 0 up to the number of fields,
  #   searchEnabled: true || false,
  #   authorizationEnabled: true || false,
  #   authorization: {
  #     type: Token || Basic,
  #     token: String
  #     username: String
  #     password: String
  #   }
  # }
