Puhsh.Posts = Backbone.Collection.extend(
  url: '/v1/posts'
  model: Puhsh.Post
  parse: (response)->
    response.items
)
