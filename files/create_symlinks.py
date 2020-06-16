#!/usr/bin/env python3
import os
import re
import shutil

files_path = os.path.dirname(os.path.realpath(__file__))
home = os.path.expanduser("~")
dir_symlinks = [
	r'.config/\w+',
	'.local/bin',
	'.vim',
	'.fonts',

]

def is_dir_symlink(path):
	for dir_symlink in dir_symlinks:
		s_path = files_path + '/' + dir_symlink.strip('/') + '$'
		if re.match(s_path, path):
			return True
	return False


def is_subdir_for_dir_symlink(path):
	for dir_symlink in dir_symlinks:
		s_path = files_path + '/' + dir_symlink.strip('/')
		if re.match(s_path, path):
			return True
	return False


for root, dirs, files in os.walk(files_path):
	if is_dir_symlink(root):
		home_path = home + root.replace(files_path, '')
		try:
			shutil.rmtree(home_path)
		except:
			pass

		try:
			os.unlink(home_path)
		except:
			pass

		print(root + ' -> ' + home_path)
		os.symlink(root, home_path)
		
		continue
	elif is_subdir_for_dir_symlink(root):
		continue

	for file in files:
		file_path = os.path.join(root, file)
		if file_path == os.path.join(files_path, __file__):
			continue

		home_path = home + file_path.replace(files_path, '')

		try:
			os.remove(home_path)
		except:
			pass

		try:
			os.unlink(home_path)
		except:
			pass

		os.makedirs(os.path.dirname(home_path), exist_ok=True)

		print(file_path + ' -> ' + home_path)
		os.symlink(file_path, home_path)
