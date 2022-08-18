import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../components/grocery_tile.dart';
import '../models/models.dart';

class GroceryItemScreen extends StatefulWidget {

  final Function(GroceryItem) onCreate;

  final Function(GroceryItem) onUpdate;

  final GroceryItem? originalItem;

  final bool isUpdating;

  const GroceryItemScreen({
    Key? key,
    required this.onCreate,
    required this.onUpdate,
    this.originalItem
  }) : isUpdating = ( originalItem != null ), super(key: key);

  @override
  _GroceryItemScreenState createState() => _GroceryItemScreenState();

}

class _GroceryItemScreenState extends State<GroceryItemScreen> {

  final _nameController = TextEditingController();
  String _name = '';
  Importance _importance = Importance.low;
  DateTime _dueDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Color _currentColor = Colors.green;
  int _currentSliderValue = 0;

  //TODO: Add initState()

  @override
  void initState() {
    super.initState();
    final originalItem = widget.originalItem;
    if (originalItem != null) {
      _nameController.text = originalItem.name;
      _name = originalItem.name;
      _currentSliderValue = originalItem.quantity;
      _importance = originalItem.importance;
      _currentColor = originalItem.color;
      final date = originalItem.date;
      _timeOfDay = TimeOfDay(hour: date.hour, minute: date.minute);
      _dueDate = date;
    }

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });

  }

  //TODO: Add dispose()

  @override
  Widget build(BuildContext context) {
    // TODO 12: Add GroceryItemScreen Scaffold
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            //TODO 24: Add callback handler
            final groceryItem = GroceryItem(
                id: widget.originalItem?.id ?? const Uuid().v1(),
                name: _nameController.text,
                importance: _importance,
                color: _currentColor,
                quantity: _currentSliderValue,
                date: DateTime(
                  _dueDate.year,
                  _dueDate.month,
                  _dueDate.day,
                  _timeOfDay.hour,
                  _timeOfDay.minute
                ));
            if (widget.isUpdating) {
              widget.onUpdate(groceryItem);
            }else {
              widget.onCreate(groceryItem);
            }
          }, icon: const Icon(Icons.check))
        ],
        elevation: 0.0,
        title: Text('Grocery Item',
          style: GoogleFonts.lato(fontWeight: FontWeight.w600),),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildNameField(),
            buildImportanceField(),
            buildDateField(),
            buildTimeField(),
            const SizedBox(height: 10.0,),
            buildColorPicker(),
            const SizedBox(height: 10.0,),
            buildQuantityField(),
            GroceryTile(item: GroceryItem(
              id: 'previewMode',
              name: _name,
              importance: _importance,
              color: _currentColor,
              quantity: _currentSliderValue,
              date: DateTime(
                _dueDate.year,
                _dueDate.month,
                _dueDate.day,
                _timeOfDay.hour,
                _timeOfDay.minute
              )
            ))
          ],
        ),
      ),

    );
  }

// TODO: Add buildNameField()
  Widget buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Item Name', style: GoogleFonts.lato(fontSize: 28.0),),
        TextField(
          controller: _nameController,
          cursorColor: _currentColor,
          decoration: InputDecoration(
            hintText: 'E.g. Apples, Banana, 1 Bag of salt',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor)
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor)
            )
          ),
        )
      ],
    );
  }

// TODO: Add buildImportanceField()
  Widget buildImportanceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Importance', style: GoogleFonts.lato(fontSize: 28.0),),
        Wrap(
          spacing: 1.0,
          children: [
            ChoiceChip(
              label: const Text('low',
                  style: TextStyle(color: Colors.white),
              ),
              selectedColor: Colors.black,
              selected: _importance == Importance.low,
              onSelected: (selected) {
                  setState(() {
                    _importance = Importance.low;
                  });
              },
            ),
            ChoiceChip(
              label: const Text('medium',
                style: TextStyle(color: Colors.white),
              ),
              selectedColor: Colors.black,
              selected: _importance == Importance.medium,
              onSelected: (selected) {
                setState(() {
                  _importance = Importance.medium;
                });
              },
            ),
            ChoiceChip(
              label: const Text('high',
                style: TextStyle(color: Colors.white),
              ),
              selectedColor: Colors.black,
              selected: _importance == Importance.high,
              onSelected: (selected) {
                setState(() {
                  _importance = Importance.high;
                });
              },
            )
          ],
        )
      ],);
  }

// TODO: ADD buildDateField()

  Widget buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Date', style: GoogleFonts.lato(fontSize: 28),),
            TextButton(onPressed: () async {
              final currentDate = DateTime.now();
              final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: currentDate,
                  lastDate: DateTime(currentDate.year + 5));
              setState(() {
                if (selectedDate != null) {
                  _dueDate = selectedDate;
                }
              });
            }, child: const Text('Select'))
          ],
        ),
        Text('${DateFormat('yyyy-MM-dd').format(_dueDate)}')
      ],
    );
  }

// TODO: Add buildTimeField()
  Widget buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Time of Day', style: GoogleFonts.lato(fontSize: 28.0),),
            TextButton(onPressed: () async{
              final timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now()
              );
              setState(() {
                if (timeOfDay != null) {
                  _timeOfDay = timeOfDay;
                }
              });
            }, child: const Text('Select'))

          ],
        ),
        Text('${_timeOfDay.format(context)}')
      ],
    );
  }

// TODO: Add buildColorPicker()
  Widget buildColorPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 50,
              width: 10,
              color: _currentColor,
            ),
            const SizedBox(width: 8.0,),
            Text('Color', style: GoogleFonts.lato(fontSize: 28.0),),
          ],
        ),
        TextButton(onPressed: () {
          showDialog(context: context, builder: (context) {
            return AlertDialog(content: BlockPicker(
              pickerColor: Colors.white,
              onColorChanged: (color) {
                setState(() {
                  _currentColor = color;
                });
              },
            ),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: const Text('Save'))
              ],);
          });
        }, child: const Text('Select'))
      ],
    );
  }

// TODO: Add buildQuantityField()
  Widget buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('Quantity', style: GoogleFonts.lato(fontSize: 28.0),),
            const SizedBox(width: 16,),
            Text(_currentSliderValue.toInt().toString(),
              style: GoogleFonts.lato(fontSize: 18.0),)
          ],
        ),
        Slider(
            value: _currentSliderValue.toDouble(),
            inactiveColor: _currentColor.withOpacity(0.5),
            activeColor: _currentColor,
            min: 0,
            max: 100,
            divisions: 100,
            label: _currentSliderValue.toInt().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value.toInt();
              });
          })
      ],
    );
  }

}