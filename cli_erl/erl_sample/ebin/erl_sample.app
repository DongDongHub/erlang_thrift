{application, 'erl_sample', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['erl_sample_app','erl_sample_sup','exampleService_thrift','example_types','http_handler','thrift_handle']},
	{registered, [erl_sample_sup]},
	{applications, [kernel,stdlib,cowboy,thrift]},
	{mod, {erl_sample_app, []}},
	{env, []}
]}.