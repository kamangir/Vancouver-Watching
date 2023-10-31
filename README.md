# Vancouver Watching (`vanwatch`) 🌈

`vanwatch` 🌈 discovers and ingests images from traffic cameras in an area and then runs [YOLO 🚀](https://github.com/ultralytics/ultralytics) and other vision algo to extract information about urban activity at scale. 

## install

```bash
abcli git clone \
    vancouver-watching \
    install
```

## Help

To receive a list of `vanwatch` commands type in,

```bash
 > vanwatch help
🌈 vancouver_watching-3.47.1
🌈 bird watching in downtown Vancouver with AI.

vancouver_watching discover \
	<area> \
	[~upload] \
	[--validate 1]
 . discover <area>.
vancouver_watching ingest \
	<area> \
	[dryrun,~upload] \
	[<object-name>] \
	[--count <-1>]
 . ingest <area> -> <object-name>.
vancouver_watching list <area> \
	[discovery|ingest]
 . list <area>.
vancouver_watching list areas
 . list areas.
```

To receive instructions about a specific command type in,

```bash
vanwatch <command> help
```

## Discover and Ingest an Area

To see the list of areas supported by `vanwatch` type in,

```bash
vanwatch list areas
```

As of revision `3.3.1` you should see `iran` 🚧 and [`vancouver`](https://opendata.vancouver.ca/explore/dataset/web-cam-url-links/map/)

To discover the available cameras in an area type in,

```bash
vanwatch discover vancouver
```

You have generated a `geojson` of [traffic images in the City of Vancouver](./data/vancouver.geojson). Now, you can ingest the traffic images from this area,

```bash
vanwatch ingest vancouver upload
```

You have downloaded a folder of ~600 images.

<img width="1552" alt="image" src="https://user-images.githubusercontent.com/1007567/196573547-b1c71b3b-7fac-4d2c-bba0-a87b063830da.png">
