#include <ruby.h>

static VALUE train(VALUE self, VALUE classes)
{
  long s_len = RARRAY_LEN(classes);
  int result = 0;

  VALUE *s_arr = RARRAY_PTR(classes);

  for(int i = 0; i < s_len; i++) {
    printf("%s\n", StringValueCStr(s_arr[i]) );
  }

  return rb_str_new2("hello world");
}

void Init_bayesian_learn()
{
  VALUE bLearn = rb_define_module("BayesianLearn");
  rb_define_singleton_method(bLearn, "train", train, 1);
}
