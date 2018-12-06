import geopandas as gpd
import sys

path="/tmp/"+sys.argv[1]+".shp"
print(path)
df = gpd.read_file(path)


def getLatLongColumns(dataframe):
    i=-1
    for col in dataframe.columns:
        i=i+1
        if col.lower()=="latitud":
            li=i
            cola=col
        if col.lower()=="longitud":
            ll=i
            colo=col
    return (cola,li),(colo,ll)


ll=getLatLongColumns(df)

fileinserts=open('/tmp/finalInsert.sql')
f = open('/tmp/finalInsert2.sql','w')
insert=fileinserts.readline()
value=fileinserts.readline()
f.write(insert)
f.write(value)
for line in df['geometry']:
    print(line)
    linei=fileinserts.readline()
    longitude=line.x
    latitude=line.y
    arr=linei.split("','")
    arr[ll[0][1]]=str(latitude)
    arr[ll[1][1]]=str(longitude)
    f.write("','".join(arr))
f.close()
fileinserts.close()
