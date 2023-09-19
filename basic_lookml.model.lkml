connection: "looker-private-demo"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

#datagroup to cache explore for 4 hours
datagroup: etl {
  max_cache_age: "4 hours"
  sql_trigger: SELECT max(id) FROM users ;; #when the value returned by the query is different than the query's prior results, then the datagroup goes into a triggered state.
}

#explore order items persisted by applying the etl datagroup
explore: users{
  persist_with: etl
  sql_always_where: ${created_date} >= '2023-01-01';; #defined in model so limiting the orders for 2023, can't see on the front-end, cannot be changed
  join: order_items{
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

#explore to join all the views, uses view labels
explore: order_items {
  label: "Order Details"
  always_filter: {
    filters: [order_items.sale_price: ">=100"] #available on front-end, user can change this filter
    #filters: [users.country: "is any value"]
  }
  join: inventory_items {
    view_label: "Inventory Items"
    type: full_outer # Get all inventory items
    relationship: one_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }
  join: users {
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }
  join: products {
    view_label: "Products"
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}

#explore to check the distribution centers
explore: distribution_centers {
  join: products{
    type: left_outer
    relationship: one_to_many
    sql_on: ${distribution_centers.id} = ${products.distribution_center_id} ;;
    fields: [distribution_centers.latitude, distribution_centers.name, distribution_centers.longitude, products.name, products.category, products.cost]
  }
}
