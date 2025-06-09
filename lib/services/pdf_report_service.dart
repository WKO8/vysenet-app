import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/device.dart';
import '../models/authorized_device.dart';

class PdfReportService {
  // Cores temáticas do projeto
  static const PdfColor primaryBlue = PdfColor.fromInt(0xFF20A4F3);
  static const PdfColor secondaryBlue = PdfColor.fromInt(0xFF448AB5);
  static const PdfColor lightBlue = PdfColor.fromInt(0xFFC1E2F6);
  static const PdfColor darkBlue = PdfColor.fromInt(0xFF1E3C4F);
  static const PdfColor greenColor = PdfColor.fromInt(0xFF5CCF88);
  static const PdfColor redColor = PdfColor.fromInt(0xFFE87676);

  static Future<Uint8List> generateNetworkReport({
    required List<Device> scannedDevices,
    required List<AuthorizedDevice> authorizedDevices,
  }) async {
    final pdf = pw.Document();
    final user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? "usuário";
    final String username = email.split('@')[0];
    final String currentDate = DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.now());
    
    final int totalScanned = scannedDevices.length;
    final int totalAuthorized = authorizedDevices.length;
    final int totalUnauthorized = totalScanned - totalAuthorized;

    // Separar dispositivos autorizados e não autorizados
    final List<Device> unauthorizedDevices = scannedDevices.where((device) {
      return !authorizedDevices.any((auth) => auth.mac == device.mac);
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Cabeçalho
            _buildHeader(username, currentDate),
            pw.SizedBox(height: 30),
            
            // Resumo executivo
            _buildExecutiveSummary(totalScanned, totalAuthorized, totalUnauthorized),
            pw.SizedBox(height: 30),
            
            // Estatísticas detalhadas
            _buildStatistics(totalScanned, totalAuthorized, totalUnauthorized),
            pw.SizedBox(height: 30),
            
            // Lista de dispositivos autorizados
            if (authorizedDevices.isNotEmpty) ...[
              _buildSectionTitle('Dispositivos Autorizados', greenColor),
              pw.SizedBox(height: 15),
              _buildAuthorizedDevicesTable(authorizedDevices),
              pw.SizedBox(height: 30),
            ],
            
            // Lista de dispositivos não autorizados
            if (unauthorizedDevices.isNotEmpty) ...[
              _buildSectionTitle('Dispositivos Não Autorizados', redColor),
              pw.SizedBox(height: 15),
              _buildUnauthorizedDevicesTable(unauthorizedDevices),
              pw.SizedBox(height: 30),
            ],
            
            // Recomendações de segurança
            _buildSecurityRecommendations(totalUnauthorized),
            pw.SizedBox(height: 30),
            
            // Rodapé
            _buildFooter(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(String username, String currentDate) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [primaryBlue, secondaryBlue],
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
        ),
        borderRadius: pw.BorderRadius.circular(15),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'VyseNet - Relatório de Rede',
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Administrador: $username',
            style: pw.TextStyle(
              fontSize: 16,
              color: PdfColors.white,
            ),
          ),
          pw.Text(
            'Data de geração: $currentDate',
            style: pw.TextStyle(
              fontSize: 16,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildExecutiveSummary(int totalScanned, int totalAuthorized, int totalUnauthorized) {
    final String securityStatus = totalUnauthorized == 0 ? 'SEGURA' : 'ATENÇÃO NECESSÁRIA';
    final PdfColor statusColor = totalUnauthorized == 0 ? greenColor : redColor;

    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: secondaryBlue, width: 2),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Resumo Executivo',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: secondaryBlue,
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            'Status da Rede: $securityStatus',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: statusColor,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Este relatório apresenta uma análise completa dos dispositivos conectados à sua rede, '
            'identificando equipamentos autorizados e potenciais riscos de segurança.',
            style: const pw.TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildStatistics(int totalScanned, int totalAuthorized, int totalUnauthorized) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard('Total Escaneados', totalScanned.toString(), secondaryBlue),
        _buildStatCard('Autorizados', totalAuthorized.toString(), greenColor),
        _buildStatCard('Não Autorizados', totalUnauthorized.toString(), redColor),
      ],
    );
  }

  static pw.Widget _buildStatCard(String label, String value, PdfColor color) {
    return pw.Container(
      width: 150,
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: color,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 32,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.white,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSectionTitle(String title, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: pw.BoxDecoration(
        color: color,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 18,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }

  static pw.Widget _buildAuthorizedDevicesTable(List<AuthorizedDevice> devices) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(2),
      },
      children: [
        // Cabeçalho
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: lightBlue),
          children: [
            _buildTableCell('Nome', isHeader: true),
            _buildTableCell('Endereço MAC', isHeader: true),
            _buildTableCell('Primeira Conexão', isHeader: true),
          ],
        ),
        // Dados
        ...devices.map((device) => pw.TableRow(
          children: [
            _buildTableCell(device.name),
            _buildTableCell(device.mac),
            _buildTableCell(device.firstSeen),
          ],
        )),
      ],
    );
  }

  static pw.Widget _buildUnauthorizedDevicesTable(List<Device> devices) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(2),
      },
      children: [
        // Cabeçalho
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFFFE5E5)),
          children: [
            _buildTableCell('Endereço IP', isHeader: true),
            _buildTableCell('Endereço MAC', isHeader: true),
            _buildTableCell('Última Detecção', isHeader: true),
          ],
        ),
        // Dados
        ...devices.map((device) => pw.TableRow(
          children: [
            _buildTableCell(device.ip),
            _buildTableCell(device.mac),
            _buildTableCell(device.lastSeen),
          ],
        )),
      ],
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _buildSecurityRecommendations(int unauthorizedCount) {
    List<String> recommendations = [
      '• Monitore regularmente os dispositivos conectados à sua rede',
      '• Configure alertas para novos dispositivos não autorizados',
      '• Mantenha senhas de rede seguras e atualizadas',
      '• Considere implementar autenticação de dois fatores quando possível',
    ];

    if (unauthorizedCount > 0) {
      recommendations.addAll([
        '• AÇÃO IMEDIATA: Investigate os dispositivos não autorizados detectados',
        '• Considere alterar as credenciais de acesso à rede',
        '• Verifique se há dispositivos desconhecidos fisicamente conectados',
      ]);
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF8F9FA),
        border: pw.Border.all(color: secondaryBlue),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Recomendações de Segurança',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: secondaryBlue,
            ),
          ),
          pw.SizedBox(height: 10),
          ...recommendations.map((rec) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Text(rec, style: const pw.TextStyle(fontSize: 12)),
          )),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: lightBlue,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Center(
        child: pw.Text(
          'Relatório gerado automaticamente pelo VyseNet\n'
          'Para mais informações sobre segurança de rede, consulte nossa documentação.',
          style: const pw.TextStyle(fontSize: 10),
          textAlign: pw.TextAlign.center,
        ),
      ),
    );
  }

  static Future<void> shareReport(Uint8List pdfBytes) async {
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'vysenet_network_report_${DateFormat('ddMMyyyy_HHmm').format(DateTime.now())}.pdf',
    );
  }

  static Future<void> printReport(Uint8List pdfBytes) async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
  }

  static Future<String> saveReportToFile(Uint8List pdfBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/vysenet_network_report_${DateFormat('ddMMyyyy_HHmm').format(DateTime.now())}.pdf');
    await file.writeAsBytes(pdfBytes);
    return file.path;
  }
} 