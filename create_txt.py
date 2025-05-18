import random

def create_random_number_file(size_mb, filename):
    size_bytes = size_mb * 1024 * 1024
    progress_step = size_bytes // 20
    next_progress = progress_step
    with open(filename, 'w') as f:
        for i in range(size_bytes):
            f.write(str(random.randint(0, 9)))
            if i + 1 == next_progress or i + 1 == size_bytes:
                percent = (i + 1) * 100 // size_bytes
                print(f"Прогресс: {percent}%")
                next_progress += progress_step

size = int(input("Введите размер файла в мегабайтах: "))
create_random_number_file(size, 'random_numbers.txt')
print(f"Файл random_numbers.txt размером {size} МБ создан.")
