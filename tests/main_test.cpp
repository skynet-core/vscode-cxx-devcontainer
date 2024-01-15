import core;
#include "gtest/gtest.h"

TEST(HelloTests, testHello) {
  auto s = test_string();
  ASSERT_STREQ("Hello Jim", s.c_str());
}