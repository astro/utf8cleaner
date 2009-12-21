#include <ruby.h>

static VALUE UTF8Cleaner_clean(VALUE obj, VALUE string)
{
  char *input = RSTRING_PTR(string);
  long i, input_len = RSTRING_LEN(string), output_len = 0;
  char *output = ALLOC_N(char, input_len);
  VALUE result;

  if (!output)
    return Qnil;

  for(i = 0; i < input_len; ++i)
  {
    long remain = input_len - i;

    /* ASCII */
    if (input[i] == '\t' ||
        input[i] == '\r' ||
        input[i] == '\n' ||
        (input[i] >= ' ' && input[i] <= 127))
    {
      output[output_len++] = input[i];
    }
    /* 2-byte sequence */
    else if (remain >= 2 &&
             (input[i] & 0xe0) == 0xc0 &&
             (input[i + 1] & 0xc0) == 0x80)
    {
      output[output_len++] = input[i++];
      output[output_len++] = input[i];
    }
    /* 3-byte sequence */
    else if (remain >= 3 &&
             (input[i] & 0xf0) == 0xe0 &&
             (input[i + 1] & 0xc0) == 0x80 &&
             (input[i + 2] & 0xc0) == 0x80)
    {
      output[output_len++] = input[i++];
      output[output_len++] = input[i++];
      output[output_len++] = input[i];
    }
    /* 4-byte sequence */
    else if (remain >= 4 &&
             (input[i] & 0xf8) == 0xf0 &&
             (input[i + 1] & 0xc0) == 0x80 &&
             (input[i + 2] & 0xc0) == 0x80 &&
             (input[i + 3] & 0xc0) == 0x80)
    {
      output[output_len++] = input[i++];
      output[output_len++] = input[i++];
      output[output_len++] = input[i++];
      output[output_len++] = input[i];
    }
    /*else
      printf("Drop(%i) %X = (%X, %X)\n", remain, (char)input[i], input[i] & 0xe0, input[i + 1] & 0xc0);*/
  }

  result = rb_str_new(output, output_len);
  free(output);
  return result;
}

void Init_utf8cleaner()
{
  VALUE rb_mUTF8Cleaner = rb_define_module("UTF8Cleaner");
  rb_define_module_function(rb_mUTF8Cleaner, "clean", &UTF8Cleaner_clean, 1);
}
