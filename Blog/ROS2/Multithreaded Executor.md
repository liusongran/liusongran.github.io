## Some notes

1. `GUARDED_BY` is an attribute on data members, which declares that the data member is protected by the given capability. Read operations on the data require shared access, while write operations require exclusive access.
2. `PT_GUARDED_BY` is similar, but is intended for use on pointers and smart pointers. There is no constraint on the data member itself, but the *data that it points to* is protected by the given capability.
3. `REQUIRES` is an attribute on functions or methods, which declares that the calling thread must have exclusive access to the given capabilities. More than one capability may be specified. The capabilities must be held on entry to the function, *and must still be held on exit*.
4. `REQUIRES_SHARED` is similar, but requires only shared access.



![image-20220720091712746](/Users/liusongran/Library/Application Support/typora-user-images/image-20220720091712746.png)

![image-20220720091738613](/Users/liusongran/Library/Application Support/typora-user-images/image-20220720091738613.png)







---

1. `get_next_executable(...)`: bool Executor::**get_next_executable**(AnyExecutable & any_executable, std::chrono::nanoseconds timeout)

2. `get_next_ready_executable(...)`: bool Executor::get_next_ready_executable(AnyExecutable & any_executable)

3. `wait_for_work(...)`: void Executor::wait_for_work(std::chrono::nanoseconds timeout)

   

4. ....

```mermaid
sequenceDiagram
	participant A as MultiThreadedExecutor::run()
	participant B as Executor::get_next_executable()
	participant C as Executor::execute_any_executable()
	participant D as Executor::get_next_ready_executable_from_map()
	participant E as Executor::wait_for_work()
	participant F as update ready_set()
	participant G as init. wait_set()
	
	
	rect rgb(221, 221, 221)
  	A-->>A: wait_lock_upper(wait_mutex_)
  	Note left of A: scheduled_timers_
	end
	A->>+B: invoke_with_lock_hold
		B->>D: 
		rect rgb(221, 221, 221)
			D-->>D: wait_lock(mutex_)
			Note right of D: memory_strategy_
		end
		D->>+F: invoke_with_lock_hold
		F-->>-D: RETURN
		D-->>B: RETURN
		
		B->>E: 
		rect rgb(221, 221, 221)
			E-->>E: wait_lock(mutex_)
			Note right of D: memory_strategy_
			Note right of D: weak_nodes_to_guard_conditions_
			Note right of D: weak_groups_associated_with_executor_to_nodes_
			Note right of D: weak_groups_to_nodes_associated_with_executor_
			Note right of D: weak_groups_to_nodes_
		end
		E->>+G: invoke_with_lock_hold
		G-->>-E: RETURN
		E-->>B: RETURN
		B->>D: 
		rect rgb(221, 221, 221)
			D-->>D: wait_lock(mutex_)
			Note right of D: memory_strategy_
		end
		D->>+F: invoke_with_lock_hold
		F-->>-D: RETURN
		D-->>B: RETURN
	
	
	
	
	
	B-->>-A: RETURN
	
	A->>C: execute_any_executable()
	C-->>A: RETURN
	
	rect rgb(221, 221, 221)
  	A-->>A: wait_lock_lower(wait_mutex_)
  	Note left of A: scheduled_timers_
	end
	
```

