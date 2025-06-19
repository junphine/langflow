# 安装依赖库（首次使用需要执行）
# pip install python-docx

from docx import Document
import csv

def extract_word_tables(file_path, output_csv=None):
    """
    提取Word文档中的表格数据
    参数：
        file_path: Word文档路径
        output_csv: 可选，输出CSV文件的路径
    返回：
        包含所有表格数据的列表（三维列表：tables[行][列][单元格]）
    """
    # 读取Word文档
    doc = Document(file_path)

    all_tables = []

    # 遍历所有表格
    for table_idx, table in enumerate(doc.tables, 1):
        table_data = []

        # 遍历表格行
        for row in table.rows:
            row_data = []

            # 遍历行中的单元格
            for cell in row.cells:
                row_data.append(cell.text.strip())

            table_data.append(row_data)

        all_tables.append(table_data)

        # 打印表格信息
        print(f"表格 {table_idx} 包含 {len(table_data)} 行 {len(table_data[0]) if table_data else 0} 列")

    # 可选：保存到CSV文件
    if output_csv:
        with open(output_csv, 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            for table in all_tables:
                writer.writerows(table)
                writer.writerow([])  # 用空行分隔不同表格
        print(f"\n数据已保存到 {output_csv}")

    return all_tables

# 使用示例
if __name__ == "__main__":
    # 替换为你的Word文档路径
    doc_path = "your_document.docx"

    # 提取数据并保存CSV
    tables = extract_word_tables(
        file_path=doc_path,
        output_csv="output.csv"
    )

    # 打印第一个表格的前两行
    print("\n示例数据：")
    for row in tables[0][:2]:
        print(row)