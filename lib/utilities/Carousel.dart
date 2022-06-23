import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Carousel {

  imageCarousel(images, imageHeight) {

    return CarouselSlider(

      options: CarouselOptions(height: imageHeight, enableInfiniteScroll: true),
      items: images.map<Widget>((image) {

        return  Builder(
          builder: (BuildContext context) {
            return CachedNetworkImage(
              imageUrl: image['imageUrl'],
              imageBuilder: (context, imageProvider) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                child:  CircularProgressIndicator(value: downloadProgress.progress, color: Colors.green,),
              ),

              errorWidget: (context, url, error) => const Icon(Icons.error),
            );
          },
        );
      }).toList(),
    );
  }

}
