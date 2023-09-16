view: order_items {
  sql_table_name: `looker-private-demo.thelook.order_items` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension_group: delivered {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }
  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }
  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }
  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }
  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format: "$#.00;($#.00)" #value format as this is a dollar amt field
  }
  dimension_group: shipped {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: total_orders {
    label: "Total orders"
    type:  count_distinct
    sql: ${TABLE}.order_id ;;
  }
  measure: total_amt {
    label: "Total Sales Amount"
    type:  sum
    sql: ${TABLE}.sale_price ;;
    value_format: "$#.00;($#.00)" #value format as this is a dollar amt field
  }
  measure: average_amt {
    label: "Average Sales Amount"
    type:  average
    sql: ${TABLE}.sale_price ;;
    value_format: "$#.00;($#.00)"
  }
  measure: maximum_amt {
    label: "Maximum Sales Amount"
    type:  max
    sql: ${TABLE}.sale_price ;;
    value_format: "$#.00;($#.00)"
  }
  measure: minimum_amt {
    label: "Minimum Sales Amount"
    type:  min
    sql: ${TABLE}.sale_price ;;
    value_format: "$#.00;($#.00)"
  }
  measure: percent_of_total_sales {
    label: "Percent of Total Sales Amount"
    type: number
    sql: ${TABLE}.sale_price/${total_amt} ;;
    value_format: "0.00%" #value format as this is a percentage field
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  users.last_name,
  users.id,
  users.first_name,
  inventory_items.id,
  inventory_items.product_name
  ]
  }

}
