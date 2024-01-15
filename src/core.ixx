module;

#include <array>
#include <atomic>
#include <iostream>
#include <thread>
#include <string>

export module core;

std::atomic_bool prepared{false};
std::atomic_bool processed{false};

std::array<int, 3> data{0};

void workerOne() {
  data[0] = 1;
  prepared.store(true, std::memory_order_relaxed);
  prepared.notify_one();
}

void workerTwo() {
  prepared.wait(false, std::memory_order_acquire);
  data[1] = 2;
  processed.store(true, std::memory_order_relaxed);
  processed.notify_one();
}

void workerThree() {
  processed.wait(false, std::memory_order_acquire);
  data[2] = 3;
}

export int run(int argc, char **argv) {
  auto t1 = std::thread(workerOne);
  auto t2 = std::thread(workerTwo);
  auto t3 = std::thread(workerThree);

  t1.join();
  t2.join();
  t3.join();

  std::cout << "[" << data[0] << ", " << data[1] << ", " << data[2] << "]"
            << std::endl;

  return 0;
}

export std::string test_string() { return std::string{"TEST"}; }