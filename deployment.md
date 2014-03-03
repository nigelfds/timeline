Deployment Process
==================

####On the development machine:

Commands executed from the source code directory.

1. Plugin the USB key (TIMELINE)

2. Export the repository to the USB key:

		git archive --format zip --output /Volumes/TIMELINE/timeline.zip master
		
3. Unmount the USB key: 

		diskutil unmount /Volumes/TIMELINE

4. Unplug the USB key
		
#####On the production machine:

Commands executed from the source code directory:

1. Plugin the USB key (TIMELINE)

2. Unzip the code to the source directory:

		unzip -o -d . /Volumes/TIMELINE/timeline.zip
		
3. Ensure that the site is built:

		middleman build
		
4. Unmount the USB key (then uplug it): 

		diskutil unmount /Volumes/TIMELINE

5. Restart the server:

		rackup




