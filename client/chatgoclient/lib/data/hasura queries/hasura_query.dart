class HasuraQuery {
//////////////////////////////////////////////////////////////////////////////////////////////////////
  static String getAllUsers({required int limit, required int offset}) => """   
   query MyQuery {
  users(limit: $limit, offset: $offset,order_by: {user_name: asc}) {
    email
    id
    user_name
  }
}
""";

//////////////////////////////////////////////////////////////////////////////////////////////////////

  static String getUserBySearchQuery({required String searchQuery}) => """

  query MyQuery {
  users(order_by: {user_name: asc}, where: {user_name: {_ilike: "$searchQuery%"}}) {
    email
    id
    user_name
  }
}


""";

//////////////////////////////////////////////////////////////////////////////////////////////////////
}
