jQuery ->
  $('body').dock(
    title: 'My First Dock',
    tabs: [
      {
        title: 'Posts',
        action: 'get',
        url: 'http://jsonplaceholder.typicode.com/posts',
        fieldNames: ['title'],
        format: '<p>%0</p>',
        searchEnabled: true,
        linkTo: 'Post Details'
      }
      {
        title: 'Post Details',
        action: 'detail',
        fieldNames: ['id', 'userId', 'title', 'body']
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
