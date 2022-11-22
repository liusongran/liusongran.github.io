[TOC]

## **`executor`**

### A. 结构体

#### I. `rclc_executor_t`

```c
/// Container for RCLC-Executor
typedef struct
{
  /// Context (to get information if ROS is up-and-running)
  rcl_context_t * context;
  /// Container for dynamic array for DDS-handles
  rclc_executor_handle_t * handles;
  /// Maximum size of array 'handles'
  size_t max_handles;
  /// Index to the next free element in array handles
  size_t index;
  /// Container to memory allocator for array handles
  const rcl_allocator_t * allocator;
  /// Wait set (is initialized only in the first call of the rclc_executor_spin_some function)
  rcl_wait_set_t wait_set;
  /// Statistics objects about total number of subscriptions, timers, clients, services, etc.
  rclc_executor_handle_counters_t info;
  /// timeout in nanoseconds for rcl_wait() used in rclc_executor_spin_once(). Default 100ms
  uint64_t timeout_ns;
  /// timepoint used for spin_period()
  rcutils_time_point_value_t invocation_time;
  /// trigger function, when to process new data
  rclc_executor_trigger_t trigger_function;
  /// application specific data structure for trigger function
  void * trigger_object;
  /// data communication semantics
  rclc_executor_semantics_t data_comm_semantics;
} rclc_executor_t;
```

#### II. `rcl_wait_set_t`

```c
/// Container for subscription's, guard condition's, etc to be waited on.
typedef struct rcl_wait_set_t
{
  /// Storage for subscription pointers.
  const rcl_subscription_t ** subscriptions;
  /// Number of subscriptions
  size_t size_of_subscriptions;
  /// Storage for guard condition pointers.
  const rcl_guard_condition_t ** guard_conditions;
  /// Number of guard_conditions
  size_t size_of_guard_conditions;
  /// Storage for timer pointers.
  const rcl_timer_t ** timers;
  /// Number of timers
  size_t size_of_timers;
  /// Storage for client pointers.
  const rcl_client_t ** clients;
  /// Number of clients
  size_t size_of_clients;
  /// Storage for service pointers.
  const rcl_service_t ** services;
  /// Number of services
  size_t size_of_services;
  /// Storage for event pointers.
  const rcl_event_t ** events;
  /// Number of events
  size_t size_of_events;
  /// Implementation specific storage.
  struct rcl_wait_set_impl_t * impl;
} rcl_wait_set_t;
```

> 1. `rcl_wait_set_impl_t`
>
>    ```c
>    typedef struct rcl_wait_set_impl_t
>    {
>      // number of subscriptions that have been added to the wait set
>      size_t subscription_index;
>      rmw_subscriptions_t rmw_subscriptions;
>      // number of guard_conditions that have been added to the wait set
>      size_t guard_condition_index;
>      rmw_guard_conditions_t rmw_guard_conditions;
>      // number of clients that have been added to the wait set
>      size_t client_index;
>      rmw_clients_t rmw_clients;
>      // number of services that have been added to the wait set
>      size_t service_index;
>      rmw_services_t rmw_services;
>      // number of events that have been added to the wait set
>      size_t event_index;
>      rmw_events_t rmw_events;
>    
>      rmw_wait_set_t * rmw_wait_set;
>      // number of timers that have been added to the wait set
>      size_t timer_index;
>      // context with which the wait set is associated
>      rcl_context_t * context;
>      // allocator used in the wait set
>      rcl_allocator_t allocator;
>    } rcl_wait_set_impl_t;
>    ```
>
> 2. `rcl_subscription_t` or `rcl_subscription_impl_t`
>
>    ```c
>    typedef struct rcl_subscription_impl_t
>    {
>      rcl_subscription_options_t options;
>      rmw_qos_profile_t actual_qos;
>      rmw_subscription_t * rmw_handle;
>    } rcl_subscription_impl_t;
>    ```
>
> 3. `rcl_timer_t` or `rcl_timer_impl_t`
>
>    ```c
>    typedef struct rcl_timer_impl_t
>    {
>      // The clock providing time.
>      rcl_clock_t * clock;
>      // The associated context.
>      rcl_context_t * context;
>      // A guard condition used to wake the associated wait set, either when
>      // ROSTime causes the timer to expire or when the timer is reset.
>      rcl_guard_condition_t guard_condition;
>      // The user supplied callback.
>      atomic_uintptr_t callback;
>      // This is a duration in nanoseconds.
>      atomic_uint_least64_t period;
>      // This is a time in nanoseconds since an unspecified time.
>      atomic_int_least64_t last_call_time;
>      // This is a time in nanoseconds since an unspecified time.
>      atomic_int_least64_t next_call_time;
>      // Credit for time elapsed before ROS time is activated or deactivated.
>      atomic_int_least64_t time_credit;
>      // A flag which indicates if the timer is canceled.
>      atomic_bool canceled;
>      // The user supplied allocator.
>      rcl_allocator_t allocator;
>    } rcl_timer_impl_t;
>    ```
>
> 4. 

### B. 初始化与操作

#### I. `rclc_executor_init(...)`

> 初始化`rclc_executor_t`结构体，

```c
rcl_ret_t
rclc_executor_init(
  rclc_executor_t * executor,
  rcl_context_t * context,
  const size_t number_of_handles,
  const rcl_allocator_t * allocator)
{
  rcl_ret_t ret = RCL_RET_OK;
  (*executor) = rclc_executor_get_zero_initialized_executor();
  executor->context = context;
  executor->max_handles = number_of_handles;
  executor->index = 0;
  executor->wait_set = rcl_get_zero_initialized_wait_set();
  executor->allocator = allocator;
  executor->timeout_ns = DEFAULT_WAIT_TIMEOUT_NS;
  // allocate memory for the array
  executor->handles =
    executor->allocator->allocate(
    (number_of_handles * sizeof(rclc_executor_handle_t)),
    executor->allocator->state);
  if (NULL == executor->handles) {
    RCL_SET_ERROR_MSG("Could not allocate memory for 'handles'.");
    return RCL_RET_BAD_ALLOC;
  }

  // initialize handle
  for (size_t i = 0; i < number_of_handles; i++) {
    rclc_executor_handle_init(&executor->handles[i], number_of_handles);
  }

  // initialize #counts for handle types
  rclc_executor_handle_counters_zero_init(&executor->info);

  // default: trigger_any which corresponds to the ROS2 rclcpp Executor semantics
  //          start processing if any handle has new data/or is ready
  rclc_executor_set_trigger(executor, rclc_executor_trigger_any, NULL);

  // default semantics
  rclc_executor_set_semantics(executor, RCLCPP_EXECUTOR);

  return ret;
}
```

#### II. `rclc_executor_add_subscription(...)`

```c
rcl_ret_t
rclc_executor_add_subscription(
  rclc_executor_t * executor,
  rcl_subscription_t * subscription,
  void * msg,
  rclc_subscription_callback_t callback,
  rclc_executor_handle_invocation_t invocation)
{
  // 1. assign data fields
  executor->handles[executor->index].type = SUBSCRIPTION;
  executor->handles[executor->index].subscription = subscription;
  executor->handles[executor->index].data = msg;
  executor->handles[executor->index].subscription_callback = callback;
  executor->handles[executor->index].invocation = invocation;
  executor->handles[executor->index].initialized = true;
  executor->handles[executor->index].callback_context = NULL;

  // 2. increase index of handle array
  executor->index++;

  // 3. invalidate wait_set so that in next spin_some() call the 'executor->wait_set' is updated accordingly
  if (rcl_wait_set_is_valid(&executor->wait_set)) {
    ret = rcl_wait_set_fini(&executor->wait_set);
    if (RCL_RET_OK != ret) {
      RCL_SET_ERROR_MSG("Could not reset wait_set in rclc_executor_add_subscription.");
      return ret;
    }
  }
  executor->info.number_of_subscriptions++;
  return ret;
}
```

### C. 执行

#### I. `rclc_executor_spin_some(...)`

```flow
st=>start: 入口
op0=>operation: 准备executor执行环境, rclc_executor_prepare(...)
op1=>operation: 初始化wait_set, rcl_wait_set_clear(...)
op2=>operation: 向wait_set中添加callback的handler, rcl_wait_set_add_subscription(...)/rcl_wait_set_add_timer(...)
op3=>operation: 等待一段时间以从DDS中获取数据, rcl_wait(wait_set, time_out_ns)
op4=>operation: 调度callback执行, _rclc_let_scheduling(...)/_rclc_default_scheduling(...)
e=>end: 返回

st->op0->op1->op2->op3->op4->e
```

```c
rcl_ret_t
rclc_executor_spin_some(rclc_executor_t * executor, const uint64_t timeout_ns)
{
  rclc_executor_prepare(executor);
  // set rmw fields to NULL
  rc = rcl_wait_set_clear(&executor->wait_set);
  if (rc != RCL_RET_OK) {
    PRINT_RCLC_ERROR(rclc_executor_spin_some, rcl_wait_set_clear);
    return rc;
  }
  // add handles to wait_set
  for (size_t i = 0; (i < executor->max_handles && executor->handles[i].initialized); i++) {
    switch (executor->handles[i].type) {
      case SUBSCRIPTION:
      case SUBSCRIPTION_WITH_CONTEXT:
        // add subscription to wait_set and save index
        rc = rcl_wait_set_add_subscription(
          &executor->wait_set, executor->handles[i].subscription,
          &executor->handles[i].index);
        break;

      case TIMER:
        // case TIMER_WITH_CONTEXT:
        // add timer to wait_set and save index
        rc = rcl_wait_set_add_timer(
          &executor->wait_set, executor->handles[i].timer,
          &executor->handles[i].index);
        break;
			...
    }
  }

  // wait up to 'timeout_ns' to receive notification about which handles reveived
  // new data from DDS queue.
  rc = rcl_wait(&executor->wait_set, timeout_ns);
  RCLC_UNUSED(rc);

  // based on semantics process input data
  switch (executor->data_comm_semantics) {
    case LET:
      rc = _rclc_let_scheduling(executor);
      break;
    case RCLCPP_EXECUTOR:
      rc = _rclc_default_scheduling(executor);
      break;
    default:
      PRINT_RCLC_ERROR(rclc_executor_spin_some, unknown_semantics);
      return RCL_RET_ERROR;
  }

  return rc;
}
```

