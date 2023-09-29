view: users {
  sql_table_name: `looker-private-demo.thelook.users` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }
  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }
  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }
  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }
  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }
  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }
  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }
  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }
  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }
  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, order_items.count]
  }
  measure: this_week_count{
    type: count_distinct
    filters: [created_date: "7 days"] #filtered measure
    sql: ${TABLE}.id ;;
  }
  dimension: age_group {
    case: {
      when: {
        sql: ${TABLE}.age < 18  ;;
        label: "Less than 18 years old "
      }
      when: {
        sql: ${TABLE}.age >= 18 and ${TABLE}.age < 26  ;;
        label: "Between 18 and 25"
      }
      when: {
        sql: ${TABLE}.age >= 26 and ${TABLE}.age < 36  ;;
        label: "Between 26 and 35"
      }
      when: {
        sql: ${TABLE}.age >= 36 and ${TABLE}.age < 46  ;;
        label: "Between 36 and 45"
      }
      when: {
        sql: ${TABLE}.age >= 46 and ${TABLE}.age < 56  ;;
        label: "Between 46 and 55"
      }
      when: {
        sql: ${TABLE}.age >= 56 and ${TABLE}.age < 66  ;;
        label: "Between 56 and 65"
      }
      else: "Greater than 65 years old"
    }
  }
  dimension: age_tier {
    label: "Age Tier"
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80]
    style: integer
    sql: ${age} ;;
  }
  dimension: user_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }
}
