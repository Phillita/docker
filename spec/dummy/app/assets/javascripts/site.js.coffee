jQuery ->
  $('body').dock(
    title: 'My First Dock',
    tabs: [
      {
        title: 'First',
        action: 'get',
        url: 'https://restcountries.eu/rest/v1/all',
        fieldNames: ['name'],
        format: '<p>%0</p>',
        searchEnabled: true
      },
      {
        title: 'Second',
        action: 'get',
        url: 'https://restcountries.eu/rest/v1/all',
        fieldNames: ['name', 'capital'],
        format: '<p>Country: %0 <br>Capital: %1</p>',
        searchEnabled: false
      }
    ]
  )
