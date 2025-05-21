import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const appName = 'AI ASSISTANT';

late Size mq;

final apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
